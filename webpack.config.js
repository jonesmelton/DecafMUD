// in case you run into any typescript error when configuring `devServer`

const path = require("path");

const config = {
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
