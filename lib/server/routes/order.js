const express = require("express");
const orderRouter = express.Router();
const admin = require('../middlewares/admin'); // Adjust path if necessary
const Order = require("../models/order"); // Ensure this path is correct
const moment = require('moment');

orderRouter.get("/admin/get-orders/:shopId", admin, async (req, res) => {
    const shopId = req.params.shopId;
    console.log(`Fetching orders for shopId: ${shopId}`);  // Log the shopId being fetched

    try {
        const allOrders = await Order.find({});

        // Log all orders to the console
        console.log(`All Orders: ${JSON.stringify(allOrders, null, 2)}`); // Log all orders retrieved

        // Filter orders based on the provided shopId
        const ordersForShop = allOrders.filter(order => order.shopId.toString() === shopId);
        
        // Log orders for the specific shopId
        console.log(`Orders found for shopId ${shopId}: ${JSON.stringify(ordersForShop, null, 2)}`);


        // Check if orders for the specified shopId were found
        if (!ordersForShop.length) {
            console.log(`No orders found for shopId ${shopId}`); // Log if no orders found
            return res.status(404).json({ error: "No orders found for this shop" });
        }

        // Return the found orders for the specified shopId
        return res.json(ordersForShop);
    } catch (e) {
        console.error("Error fetching orders:", e.message);
        return res.status(500).json({ error: "Failed to fetch orders: " + e.message });
    }
});

orderRouter.post("/admin/change-order-status", admin, async (req, res) => {
    try {
      const { id, status } = req.body;
      let order = await Order.findOne({ _id: id, status: { $lt: 4 } });
      if (!order) {
        return res.status(404).json({ error: "Order not found or status is not less than 3" });
      }
      order.status = status;
      order = await order.save();
      res.json(order);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });


  orderRouter.get("/admin/order-status/:orderId", admin, async (req, res) => {
    try {
      const { orderId } = req.params;
      const order = await Order.findById(orderId);
      if (!order) {
        return res.status(404).json({ error: "Order not found" });
      }
      res.json({ status: order.status });
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });


  //fetch all orders based on shopId
orderRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const { shopId, date } = req.query;
    const startDate = moment(date).startOf('day').valueOf();
const endDate = moment(date).endOf('day').valueOf();

const orders = await Order.find({
  shopId,
  orderedAt: { $gte: startDate, $lte: endDate }
});

    console.log(`Fetched Orders for shopId ${shopId} and date ${date}:`, orders);
    res.json(orders);
  } catch (e) {
    console.error("Error fetching orders:", e);
    res.status(500).json({ error: e.message });
  }
});
  

module.exports = orderRouter;
