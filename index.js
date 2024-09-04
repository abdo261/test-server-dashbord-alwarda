const express = require("express");
const cors = require("cors");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: [
      'https://client-dashboard-alwarda.vercel.app',
      'https://client-dashboard-alwa-git-ccae60-abdellah-ait-bachikhs-projects.vercel.app',
      'https://client-dashboard-alwarda-nsi8li84g.vercel.app'
    ],
    methods: ["GET", "POST"],
  },
});

// Custom CORS function to handle multiple origins
const allowedOrigins = [
  'https://client-dashboard-alwarda.vercel.app',
  'https://client-dashboard-alwa-git-ccae60-abdellah-ait-bachikhs-projects.vercel.app',
  'https://client-dashboard-alwarda-nsi8li84g.vercel.app'
];

const corsOptions = {
  origin: function (origin, callback) {
    if (allowedOrigins.indexOf(origin) !== -1 || !origin) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
};

// Middleware
app.use(cors(corsOptions));
app.use(express.json());

// Routes
app.use("/api/students", studentRouter);
app.use("/api/centres", centreRouter);
app.use("/api/levels", levelRouter);
app.use("/api/subjects", subjectRouter);
app.use("/api/users", userRouter);
app.use("/api/payments", paymentsRouter);
app.use("/api/auth", authRouterRouter);

// Socket.IO event handling
io.on("connection", (socket) => {
  console.log(`User connected: ${socket.id}`);

  socket.on("disconnect", () => {
    console.log(`User disconnected: ${socket.id}`);
  });

  socket.on("message", (data) => {
    console.log(`Message from ${socket.id}:`, data);

    io.emit("message", data);
  });
});

// Start the server
const PORT = process.env.PORT || 5000;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
});
