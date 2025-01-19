const mongoose = require("mongoose");

const productSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },

  description: {
    type: String,
    required: true,
    trim: true,
  },

  category:{
    type: String,
    required:true,
    trim:true,
  },

  subCategory: {
    type: String,
    required: true,
    trim: true,
  },

  offer : {
    type : String,
    trim : true,
  },

  
  price: {
    type: Number,
    required: true,
    trim: true,
  },

  discountPrice: {
    type: Number,
    trim: true,
  },

  basePrice: {
    type: Number,
    trim: true,
  },
  
  images: [
    {
      type: String,
      required: true,
    },
  ],

  quantity: {
    type: Number,
    // required: true,
  },

  colors: {
    type: [String],
    default: [],
  },

  size: {
    type: [String],
    default: [],
  },

  note: {
    type: String,
    trim: true, 
  }, 

});

const Product = mongoose.model("Product", productSchema);
module.exports = { Product,   productSchema };