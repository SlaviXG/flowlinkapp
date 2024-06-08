from pynput import keyboard
import socket


# Set up the socket server
def setup_server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('localhost', 65432))
    server_socket.listen(1)
    print("Server listening on port 65432")
    conn, addr = server_socket.accept()
    print(f"Connection from {addr}")
    return conn


# Define the hotkey action
def on_activate():
    print('Global hotkey activated!')
    try:
        conn.sendall(b'Global hotkey activated!\n')
    except Exception as e:
        print(e)


def for_canonical(f):
    return lambda k: f(listener.canonical(k))


# Set up the server connection
conn = setup_server()

# Set up the hotkey listener
hotkey = keyboard.HotKey(
    keyboard.HotKey.parse('<alt>+p'),
    on_activate
)

with keyboard.Listener(
        on_press=for_canonical(hotkey.press),
        on_release=for_canonical(hotkey.release)) as listener:
    listener.join()
