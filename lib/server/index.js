const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const orderRouter = require('./routes/order');

const auth = require('./middlewares/auth'); // Adjust path as necessary

// const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

const PORT = 5000;
const app = express();

const DB = "mongodb+srv://shivprasadrahulwad:Rshivam1234@cluster.tegl0.mongodb.net/?retryWrites=true&w=majority&appName=Cluster"

app.use(express.json());

app.use(authRouter);
app.use(adminRouter);
app.use(userRouter);
app.use(orderRouter);



mongoose.connect(DB).then(() => {
    console.log("Connection successful");
}).catch((e) => {
    console.log(e);
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected Port ${PORT}`);
});



