
var path = require("path");
var config = {
    mode: "development",
    entry: "./src/index.ts",
    devtool: "source-map",
    output: {
        filename: "main.bundle.js",
        path: path.resolve(__dirname, "dist"),
    },
    resolve: {
        extensions: [".ts", ".js"],
    },
    // loaders
    module: {
        rules: [
            {
                test: /\.tsx?/,
                use: "ts-loader",
                exclude: /node_modules/,
            },
        ],
    },
};
module.exports = config;
//# sourceMappingURL=webpack.config.js.map