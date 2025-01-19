// const jwt = require("jsonwebtoken");
// const Admin = require("../models/admin");

// // Middleware to check if the user is an admin
// const admin = async (req, res, next) => {
//   try {
//     // Retrieve token from request headers
//     const token = req.header("x-auth-token");
//     if (!token) {
//       return res.status(401).json({ msg: "No auth token, access denied" });
//     }

//     // Verify the token
//     const verified = jwt.verify(token, process.env.JWT_SECRET || "passwordKey");
//     if (!verified) {
//       return res.status(401).json({ msg: "Token verification failed, authorization denied." });
//     }

//     // Find the user by ID from the verified token
//     const user = await Admin.findById(verified.id);
//     if (!user) {
//       return res.status(404).json({ msg: "Admin user not found." });
//     }

//     // Check if the user is an admin
//     if (user.type !== "admin") {  // Ensure only admins are allowed
//       return res.status(403).json({ msg: "You are not an admin!" });
//     }

//     // Attach user/admin info to the request object
//     req.admin = verified.id; // Changed to req.admin for consistency
//     req.token = token;
//     next();  // Proceed to the next middleware or route handler
//   } catch (err) {
//     // Handle any errors that occur
//     console.error(err);  // Log the error for debugging
//     res.status(500).json({ error: err.message });
//   }
// };

// module.exports = admin;


const jwt = require("jsonwebtoken");
const Admin = require("../models/admin");


const admin = async (req, res, next) => {
  try {
    console.log("Admin middleware executing");
    
    const token = req.header("x-auth-token");
    console.log("Token received:", token ? "Yes" : "No");
    
    if (!token) {
      console.log("No auth token provided");
      return res.status(401).json({ msg: "No auth token, access denied" });
    }

    const JWT_SECRET = process.env.JWT_SECRET || "passwordKey";
    const verified = jwt.verify(token, JWT_SECRET);
    console.log("Token verification:", verified ? "Successful" : "Failed");
    
    if (!verified) {
      console.log("Token verification failed");
      return res.status(401).json({ msg: "Token verification failed, authorization denied." });
    }

    const user = await Admin.findById(verified.id);
    console.log("Admin user found:", user ? "Yes" : "No");
    
    if (!user) {
      console.log("Admin user not found");
      return res.status(404).json({ msg: "Admin user not found." });
    }

    if (user.type !== "admin") {
      console.log("User is not an admin");
      return res.status(403).json({ msg: "You are not an admin!" });
    }

    req.admin = verified.id;
    req.token = token;
    console.log("Admin middleware completed successfully");
    next();
  } catch (err) {
    console.error("Admin middleware error:", {
      name: err.name,
      message: err.message,
      stack: err.stack
    });
    res.status(500).json({ error: err.message });
  }
};

module.exports = admin;