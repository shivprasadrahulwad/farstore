const mongoose = require("mongoose");
const { productSchema } = require("./product");
const { shopInfoSchema } = require("./shopInfo");
const ratingSchema = require("./ratings");


const adminSchema = mongoose.Schema({
  name: {
    required: false,
    type: String,
    trim: true,
  },
  email: {
    required: false,
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
    required: false,
    type: String,
  },
  address: {
    type: String,
    default: "Pune, Maharashtra",
  },
  type: {
    type: String,
    default: "admin",
  },

  productsInfo :[
    {
      product: productSchema,
    }
  ],

  shopDetails: [shopInfoSchema],

  shopCode:{
    type: String,
    default: '123456'
  },

});

const Admin = mongoose.model("Admin", adminSchema);
module.exports = Admin;

