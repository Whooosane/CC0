// NPM Packages
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
require("dotenv").config();
const app = express();
const http = require("http");
const server = http.createServer(app);

// Project files and routes
const apiRouter = require("./Routes");
const connect = require("./Config/db");
const socketIO = require("./Socket/socket");

// Connect to database
connect();

// Middlewares
app.use(bodyParser.json());
app.use(cors());

// Default route for "/"
app.get("/", (req, res) => {
  res.send("Welcome to Circle Server! 🚀");
});

// Connecting routes
app.use("/api", apiRouter);

// Pass the HTTP server instance to the Socket.IO module
socketIO.init(server);

// Connect Server
const PORT = process.env.PORT || 5001;
server.listen(PORT, () => {
  console.log(`Your app is running on PORT ${PORT}`);
});
