const mongoose = require("mongoose");
const { productSchema } = require("./product");
const { shopInfoSchema } = require("./shopInfo");


const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    required: true,
    type: String,
  },
  address: {
    type: String,
    default: "Pune, Maharashtra",
  },
  type: {
    type: String,
    default: "user",
  },

  cart :[
    {
      product: productSchema,
      quantity:{
        type:Number,
        default:1
      }
    }
  ],


  shopCodes:[
    {
      shopInfo: shopInfoSchema,
    }
  ]
});

const User = mongoose.model("User", userSchema);
module.exports = User;

