# seud0nym's Home Assistant App Repository


## App Repository Installation

### Automatic

[![Open your Home Assistant instance and show the add app repository dialogue with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fhome-assistant-addons)

### Manual

Follow these steps to get the app repository installed on your system:

1. Navigate in your Home Assistant frontend to **Settings** -> **Apps** -> **App store**.
1. Click the three vertical dots in the top-right corner and select **Repositories**.
1. Enter https://github.com/seud0nym/home-assistant-addons and click the **ADD** button.
1. Close the Repositories window and refresh.


## Beta Channel

A beta channel is available for testing new features and bug fixes before stable releases. Beta apps require **Advanced Mode** enabled in your Home Assistant profile.

> [!IMPORTANT]
> Stable and beta releases do _not_ share configuration. If you have configured an app through the `addon_configs` directory, you _must_ update the directory contents for both the stable and beta releases if you switch between them.

### Automatic

[![Open your Home Assistant instance and show the add app repository dialogue with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fhome-assistant-addons%23beta)

### Manual

1. Navigate in your Home Assistant frontend to **Settings** -> **Apps** -> **App store**.
1. Click the three vertical dots in the top-right corner and select **Repositories**.
1. Enter https://github.com/seud0nym/home-assistant-addons#beta and click the **ADD** button.
1. Close the Repositories window and refresh.

> [!WARNING]
> Running both stable and beta versions simultaneously is not recommended. The app can _not_ detect or prevent this.
> It is up to _you_ to ensure that you do not run both the stable and beta releases simultaneously!
