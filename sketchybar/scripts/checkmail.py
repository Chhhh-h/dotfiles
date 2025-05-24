#!/usr/bin/env python3
from imapclient import IMAPClient

# ----------- 修改你的邮箱配置 ----------------
HOST = "imap.gmail.com"     # Gmail 示例
USERNAME = "ccaius502@gmail.com"
PASSWORD = "qbgxrhiggdpibrpf"  # 推荐使用 App 密码
MAILBOX = "INBOX"
# -------------------------------------------

def check_unread():
    try:
        with IMAPClient(HOST, ssl=True) as server:
            server.login(USERNAME, PASSWORD)
            server.select_folder(MAILBOX)
            unread = server.search(['UNSEEN'])  # 获取未读邮件列表
            print(len(unread))  # 输出未读邮件数
    except Exception as e:
        print("Error:", str(e))
        
check_unread()