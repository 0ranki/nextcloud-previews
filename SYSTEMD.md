## Running the pod as a systemd service

- Copy `examples/pod-nextcloud.service` to your (preferably non-root) user's `$HOME/.config/systemd/user/` folder (create the directories if they don't exist yet)
- Check that the paths are correct in the file. You can rename the service file too.
- `sudo loginctl enable-linger $USER` to allow the user's services keep running after logout
- `systemctl --user enable --now pod-nextcloud.service`

To update all the images and restart, run `systemctl --user restart pod-nextcloud.service`.

It might be a good idea to use the major version as the container tags instead of `latest` to avoid accidentally upgrading and ending up with e.g. uncompatible
apps in Nextcloud.