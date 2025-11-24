/* .vscode/run-simulator.js */
const { spawn } = require("child_process");
const path = require("path");

const pdxPath = path.join(process.cwd(), "build", "Game.pdx");

const child = spawn("open", ["-a", "Playdate Simulator", pdxPath], {
  stdio: "inherit"
});

child.on("exit", (code) => process.exit(code));
