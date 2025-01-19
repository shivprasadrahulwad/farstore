const mongoose = require("mongoose");

const categorySchema = mongoose.Schema({
  categoryName: {
    type: String,
    required: false,
    default:'Shoe'
  },
  subcategories: [
    {
      type: String,
      default:['white','balck']
    },
  ],
  categoryImage: {
    type: String,
    required: false,
    default:'category imagessss'
  },
});

const Category = mongoose.model("Category", categorySchema);
module.exports = { Category, categorySchema };
