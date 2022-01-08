# Community Hass.io Add-ons: SBFspot

![release-shield] ![project-stage-shield] ![Project Maintenance][maintenance-shield]

This [home assistant](https://www.home-assistant.io/getting-started/) add-on provides the installation, configuration, and integration for [SBFspot](https://github.com/habuild/hassio-addons/tree/master/sbfspot).

This add-on installs a cron service for SPFspot uploader at 5 minutely daytime interval, [PVoutput](https://pvoutput.org/) account and API are required, it also requires an SQL database like Mariadb. 
It also sends a MQTT message to home assistant, therefore a MQTT broker is required.

### **SBFspot Documentation**
Refer to the [Wiki](https://github.com/SBFspot/SBFspot/wiki) for documentation and FAQ.

[release]: https://github.com/habuild/hassio-addons/tree/master/sbfspot/v2022.1.1
[release-shield]: https://img.shields.io/badge/version-v2022.1.1-blue.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-experimental-yellow.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2022.svg
