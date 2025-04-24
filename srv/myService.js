module.exports = srv => {
    srv.on('hello', function(req,res) {
        var name = req.data.name;
        return "Welcome Mr, " + name;
    })
}

