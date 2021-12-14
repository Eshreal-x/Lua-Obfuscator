/*
    Luamin.js rewritten by Herrtt#3868, originally written by Stravant(?idk)

    Send me bugs or some shit idk pls dont ask for help figure it out yourself
    ok

    // Important stuff
    // YOU NEED NODE INSTALLED TO PATH! https://nodejs.org/en/download/

    const luamin = require("./luamin") // To require the library

    // Both functions (Minify & Beautify) will return the outputted values

    const options = {
        RenameVariables: <bool>,
        RenameGlobals: <bool>,
        SolveMath: <bool>,
    }

    <string> luamin.Minify(<string> src [, <object> options)
    <string> luamin.Beautify(<string> src [, <object> options)

    Thats all you need to know to use this.
*/



// I just wrote this quick cli program
// Options

let inputFile = "minifier/input.lua" // Where to grab the input file
let outputFile = "output.lua" // Where to write output



let option = "b" // Option, minify / beautify
let renameVariables = true
let renameGlobals = true
let solveMath = true


// Ignore this shit
const readline = require('readline');
const luamin = require("./luamin") // should be in same folder as this script
const fs = require("fs") // to read files, to install: `npm i fs`, https://www.npmjs.com/package/fs

const sleep = (milliseconds) => {
    return new Promise(resolve => setTimeout(resolve, milliseconds))
}


function Main() {
    fs.readFile(`${inputFile}`, "utf8", (err, src) => {
        if (err) throw err;

        let opts = {
            RenameVariables: true,
            RenameGlobals: false,
            SolveMath: false,
        }

        let writeWhat = luamin.Minify(src, opts)

        if (writeWhat != null) {
            fs.writeFile(outputFile, writeWhat, (err) => {
                if (err) throw err;
                console.log(`saved to ${outputFile}`)
            })
        } else {
            throw("something went wront!")
        }
    })
}

Main();