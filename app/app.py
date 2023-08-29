import pymysql
from flask import Flask


app = Flask(__name__)


@app.route('/')
def home():
    # 创建连接
    conn = pymysql.connect(
        host='127.0.0.1',  # 主机名或IP地址
        user='root',  # 用户名
        password='root',  # 密码
        database='qsnctf',  # 数据库名
        charset='utf8'  # 使用的字符集
    )
    # 创建游标
    cursor = conn.cursor()

    # 执行查询语句
    query = "SELECT * FROM user"
    cursor.execute(query)

    # 获取查询结果
    results = cursor.fetchall()
    data = ""
    for result in results:
        data += str(result) + "<br>"
        # 关闭游标和连接
    cursor.close()
    conn.close()
    return "欢迎使用Python, 此页面由青少年CTF构建。<hr>Data:=<br>"+data


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
