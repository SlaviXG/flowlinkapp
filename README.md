<h1>
  <img src="assets/flowlink_logo.png" alt="FlowLink Logo" width="30" height="30">
  FlowLink
</h1>

FlowLink is an application that harnesses the power of Gemini, Google Tasks, and Google Calendar APIs to enhance productivity and streamline busy lifestyles. Simply select the text, click your designated button (or use a hotkey, depending on your settings), and let the application manage the content, whether it's an event or a task you need to complete.

<br>
!Provide video link!
<br>

## Requirements
### Windows
- Dart & Flutter

### Linux & macOS
The app was not tested for Linux and MacOS. But this package will be required.
- `keybinder-3.0`
Run the following command:
```shell sudo apt-get install keybinder-3.0```

## Preparation
1. In Google Cloud services set up a project.
2. Enable Google Tasks API, Google Calendar API and Generative Language API for this project.
3. Obtain Gemini API Key.
4. Set up OAuth 2.0 for the project. Obtain Client ID, Project ID and Client Secret.
5. Set up OAuth consent screen (add test users or publish the app for production).

## Build & Run
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

3. Run

```bash
    flutter run -d windows
```

<<<<<<< HEAD
_*For successful login the user should be either added to the list of test users, or the general group permission modifier should be changed._
=======
For successful login the user should be either added to the list of test users, or the general group permission modifier should be changed.
>>>>>>> 185a5fab039e931b4c41311f268d7a8e873da4df
