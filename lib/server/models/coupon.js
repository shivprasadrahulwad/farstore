const mongoose = require("mongoose");

const couponSchema = mongoose.Schema({
  couponCode: {
    type: String,
    required: true,
    unique: true,
    uppercase: true, 
    trim: true,
    validate: {
      validator: function(v) {
        return v.length > 0; 
      },
      message: 'Coupon code cannot be empty'
    }
  },
  off: {
    type: Number,
    required: true,
    min: 0,
    max: 100, 
    validate: {
      validator: function(v) {
        return !isNaN(v); 
      },
      message: 'Percentage off must be a valid number'
    }
  },
  price: {
    type: Number,
    required: true,
    min: 0,
    validate: {
      validator: function(v) {
        return !isNaN(v); // Matches UI validation for valid number
      },
      message: 'Minimum purchase value must be a valid number'
    }
  },

  customLimit: {
    type: Number,
    min: 0,
  },

  limit: {
    type: Boolean,
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
  },

  
  createdAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});


// couponSchema.index({ couponCode: 1 });

couponSchema.statics.countCoupons = async function() {
  const count = await this.countDocuments();
  if (count >= 6) {
    throw new Error('Maximum limit of 6 coupons reached');
  }
};

const Coupon = mongoose.model("Coupon", couponSchema);
module.exports = { Coupon, couponSchema };