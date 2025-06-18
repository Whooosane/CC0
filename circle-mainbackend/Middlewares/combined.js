const { customerMiddleware } = require("../Middlewares/user");
const { adminMiddleware } = require("../Middlewares/admin");

// Middleware wrapper to allow either customer or admin
module.exports.combinedMiddleware = async (req, res, next) => {
    try {

        await customerMiddleware(req, res, async (customerErr) => {
            if (!customerErr) {
                return next(); // Customer authorized
            }

            // If customer authorization fails, try admin authorization
            await adminMiddleware(req, res, (adminErr) => {
                if (!adminErr) {
                    return next(); // Admin authorized
                }

                // If both fail, send an error response
                res.status(403).json({ message: 'Access denied' });
            });
        });
    } catch (error) {
        res.status(500).json({ message: 'Authentication error' });
    }
};