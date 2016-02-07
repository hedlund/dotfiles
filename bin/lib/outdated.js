'use strict';

const exec = require('child_process').exec;
const execSync = require('child_process').execSync;

const GitStatus = {
    UPTODATE: 0,
    NEEDPULL: 1,
    NEEDPUSH: 2,
    DIVERGED: 3
};

function outdatedDotfiles(callback) {
    if (callback) {
        const git = cmd => execSync(`git ${cmd}`, { cwd: __dirname, encoding: 'utf8' });

        git('fetch');

        const local = git('rev-parse @');
        const remote = git('rev-parse @{u}');
        const base = git('merge-base @ @{u}');

        if (local === remote) {
            callback(GitStatus.UPTODATE);
        }
        else if (local === base) {
            callback(GitStatus.NEEDPULL);
        }
        else if (remote === base) {
            callback(GitStatus.NEEDPUSH);
        }
        else {
            callback(GitStatus.DIVERGED);
        }
    }
}

function outdatedBrews(callback) {
    if (callback) {
        exec('brew outdated', (error, stdout, stderr) => {
        	const outdated = stdout.toString().split('\n').filter(str => str.trim().length > 0);
        	callback(outdated);
        });
    }
}

function outdatedCasks(callback) {
    if (callback) {
        exec('brew cask list', (error, stdout, stderr) => {
            let outdated = [];
            const installed = stdout.toString().trim().split('\n');
            installed.forEach(app => {
                exec(`brew cask info ${app}`, (error, stdout, stderr) => {
                    outdated.push(stdout.toString().includes('Not installed')? app : null);
                    if (outdated.length === installed.length) {
                        callback(outdated.filter(Boolean));
                    }
                });
            })
        });
    }
}

function listOutdated(callback, cmd, regex) {
    if (callback) {
    	exec(cmd, (error, stdout, stderr) => {
    		const rows = stdout.toString().split('\n');
    		const outdated = rows.map(row => {
    			const match = new RegExp(regex).exec(row);
    			return match? match[1] : null;
    		}).filter(Boolean);
    		callback(outdated);
    	});
    }
}

module.exports = {
    dot: outdatedDotfiles,
    brew: outdatedBrews,
    cask: outdatedCasks,
    sdk: cb => listOutdated(cb, 'source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk outdated', /(\w+)\s\(.*\)/g),
    npm: cb => listOutdated(cb, 'npm outdated -g --color=false', /^(\w+)\s+\d+\.\d+\.\d+\s+.+\s+.+/g),
    apm: cb => listOutdated(cb, 'apm outdated --color=false', /── ([\w-]+) .+ -> .+/g),

    GitStatus: GitStatus
};
