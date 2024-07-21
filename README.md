# FlowLink

FlowLink is an application that harnesses the power of Gemini, Google Tasks, and Google Calendar APIs to enhance productivity and streamline busy lifestyles. Simply select the text, click your designated button (or use a hotkey, depending on your settings), and let the application manage the content, whether it's an event or a task you need to complete.

<br>
!Provide video link!
<br>

## Requirements
### Windows
### Linux
- `keybinder-3.0`

Run the following command:
```shell sudo apt-get install keybinder-3.0```

## Build & run
1. In the main directory, create `secrets.json` file.
2. Pase the following content and provide your gemini api key, google cloud client id, project id and the secret.
```
{
    {   
    "data_processor": {
        "services": {
            "gemini": {
                "api_key": "YOUR GEMINI API KEY"
            },
            "flowlink": {
                "client_id":"YOUR CLIENT ID",
                "project_id":"YOUR PROJECT ID",
                "auth_uri":"https://accounts.google.com/o/oauth2/auth",
                "token_uri":"https://oauth2.googleapis.com/token",
                "auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs",
                "client_secret":"YOUR CLIENT SECRET",
                "redirect_uris":["http://localhost"]
            }
        }
    }
}
}
```

2. Run
```bash
    flutter run -d windows
```