const mongoose = require("mongoose");

const offerDescriptionSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    maxLength: 40 // Matching the Flutter maxLength constraint
  },
  description: {
    type: String,
    required: true,
    maxLength: 40 // Matching the Flutter maxLength constraint
  },
  icon: {
    type: String,
    required: true,
    validate: {
      validator: function(v) {
        // Validate that it's in the format "IconData(U+XXXXX)"
        return /^(Icons\.|IconData\(U\+)[A-Za-z0-9_]+\)?$/.test(v);
      },
      message: props => `${props.value} is not a valid icon format!`
    }
  },
});

const OfferDes = mongoose.model("OfferDes", offerDescriptionSchema);
module.exports = { OfferDes,offerDescriptionSchema};