const jwt = require('jsonwebtoken');
const userModel = require('../Models/user');

module.exports.customerMiddleware = async (req, res, next) => {
    try {
        let token;
        if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")) {
            token = req.headers.authorization.split(" ")[1];

            const decoded = jwt.verify(token.trim(), process.env.SECRET);

            req.user = await userModel.findById(decoded.id).select("-password");
            if (!req.user) {
                return next(new Error('Access denied: User not found'));
            }

            next(); // Pass control if successful
        } else {
            return next(new Error('No token provided'));
        }
    } catch (error) {
        return next(error); // Ensure errors are passed properly
    }
};


