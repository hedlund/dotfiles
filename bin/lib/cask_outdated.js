'use strict';

const exec = require('child_process').exec;

module.exports = function(callback) {
    exec('brew cask list', (error, stdout, stderr) => {
        let outdated = [];
        const installed = stdout.toString().trim().split('\n');
        installed.forEach(app => {
            exec(`brew cask info ${app}`, (error, stdout, stderr) => {
                outdated.push(stdout.toString().includes('Not installed')? app : null);
                if (outdated.length === installed.length && callback) {
                    callback(outdated.filter(Boolean));
                }
            });
        })
    });
};
