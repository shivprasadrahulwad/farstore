const mongoose = require("mongoose");

const chargesSchema = new mongoose.Schema({
  isDeliveryChargesEnabled: {
    type: Boolean,
    // required: true,
    default: false
  },
  deliveryCharges: {
    type: Number,
    required: false,
    default: 0,
  },
  startDate: {
    type: Date,
    required: false,
  },
  endDate: {
    type: Date,
    required: false,
  },
  startTime: {
    type: Number, 
    required: false,
  },
  endTime: {
    type: Number,
    required: false,
  }
});

chargesSchema.statics.fromAPIFormat = function(apiCharges) {
  return {
    isDeliveryChargesEnabled: apiCharges.isEnabled,
    deliveryCharges: parseFloat(apiCharges.charges),
    startDate: apiCharges.schedule?.startDate,
    endDate: apiCharges.schedule?.endDate,
    startTime: apiCharges.schedule?.startTime,
    endTime: apiCharges.schedule?.endTime
  };
};

const Charges = mongoose.model("Charges", chargesSchema);
module.exports = { Charges,chargesSchema};
