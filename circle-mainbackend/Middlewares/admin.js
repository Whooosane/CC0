const jwt = require('jsonwebtoken');
const adminModel = require('../Models/admin');

module.exports.adminMiddleware = async (req, res, next) => {
    try {
        let token;
        if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")) {
            try {
                token = req.headers.authorization.split(" ")[1];  
                const decoded = jwt.verify(token.trim(), process.env.SECRET);
                req.admin = await adminModel.findById(decoded.id).select("-password");


                if (!req.admin) {
        
                    return res.status(403).json({ message: 'Access denied: Admin not found' });
                }

                next(); 

            } catch (error) {
                
                return res.status(401).json({ message: "Not authorized, invalid token" });
            }
        }

        if (!token) {

            return res.status(401).json({ message: "Not authorized, token missing" });
        }

    } catch (error) {
        
        return res.status(500).json({ message: "Internal server error" });
    }
}
