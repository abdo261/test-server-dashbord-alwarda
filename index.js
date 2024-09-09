const express = require("express");
const cors = require("cors");
const http = require("http");
const { Server } = require("socket.io");
const jwt = require('jsonwebtoken')
const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: [
      'https://client-dashboard-alwarda.vercel.app',
      'https://client-dashboard-alwa-git-ccae60-abdellah-ait-bachikhs-projects.vercel.app',
      'https://client-dashboard-alwarda-nsi8li84g.vercel.app',
      "https://client-dashboard-alwarda.vercel.app/",
      "http://localhost:3000"
    ],
    methods: ["GET", "POST"],
  },
});

require("dotenv").config();

const userRouter = require("./router/user");
const studentRouter = require("./router/student");
const centreRouter = require("./router/centre");
const levelRouter = require("./router/level");
const subjectRouter = require("./router/subject");
const paymentsRouter = require("./router/payment");
const authRouterRouter = require("./router/auth");
const authenticateJWT = require("./middleware/authenticateJWT");

// Middleware
app.use(cors({
  origin: [
    'https://client-dashboard-alwarda.vercel.app',
    'https://client-dashboard-alwa-git-ccae60-abdellah-ait-bachikhs-projects.vercel.app',
    'https://client-dashboard-alwarda-nsi8li84g.vercel.app',
    "https://client-dashboard-alwarda.vercel.app/",
    "http://localhost:3000"
  ],
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use((req, res, next) => {
  const excludedRoutes = ["/api/auth/login"];
  if (excludedRoutes.includes(req.path)) {
    return next(); 
  }
  authenticateJWT(req, res, next);
});
app.use(express.json());

// Routes
app.use("/api/students", studentRouter);
app.use("/api/centres", centreRouter);
app.use("/api/levels", levelRouter);
app.use("/api/subjects", subjectRouter);
app.use("/api/users", userRouter);
app.use("/api/payments", paymentsRouter);
app.use("/api/auth", authRouterRouter);



const connectedClients = []; // Array to store connected user IDs
const socketToUserMap = {}; // Mapping from socket IDs to user IDs

io.on('connection', (socket) => {
  // Listen for the token sent by the client
  socket.on('conectCLintId', (token) => {
    try {
      // Verify and decode the token to get user information
      const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secretkey');
      const userId = decoded.id;

      // Add the user ID to the list
      if (!connectedClients.includes(userId)) {
        connectedClients.push(userId);
      }

      // Map the socket ID to the user ID
      socketToUserMap[socket.id] = userId;

      console.log(`User connected: ${userId}`);
      
      // Broadcast the list of connected clients to all clients
      io.emit('connectedClients', connectedClients);

    } catch (err) {
      console.error('Token verification failed:', err);
    }
  });

  // Handle disconnection
  socket.on('disconnect', () => {
    // Find the user ID associated with this socket ID
    const userId = socketToUserMap[socket.id];

    if (userId) {
      // Remove the user ID from the list
      const index = connectedClients.indexOf(userId);
      if (index !== -1) {
        connectedClients.splice(index, 1);
        console.log(`User disconnected: ${userId}`);
      }
      // Remove the socket ID from the map
      delete socketToUserMap[socket.id];
    }

    // Broadcast the updated list of connected clients
    io.emit('connectedClients', connectedClients);
  });
});


// require('./jobs/createMonthlyFees')
// Start the server
const PORT = process.env.PORT || 5000;
server.listen(PORT,'0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
});
