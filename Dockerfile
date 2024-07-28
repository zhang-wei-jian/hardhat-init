# 使用 Node.js 作为基础镜像
FROM node:18

# 创建应用目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖项
RUN npm install

# 复制项目文件
COPY . .

# 暴露 Hardhat Node 默认端口
EXPOSE 8545


# 启动 Hardhat Node
CMD ["npx", "hardhat", "node", "--hostname", "0.0.0.0"]
