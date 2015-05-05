yum-mirror Cookbook [![Build Status](https://travis-ci.org/TheFurya/chef-yum-mirror.svg?branch=master)](https://travis-ci.org/TheFurya/chef-yum-mirror)
====================

This cookbook will install all tools to create a local mirror of a yum repository.

Requirements
------------

#### OS

Tested on CentOS 6.6 with repositories for CentOS 6 and 7.

#### Cookbooks
- `yum` - yum-mirror needs yum to add repositories

Attributes
----------

#### yum-mirror::default
| Key                        | Type   | Description                               | Default             |
| :------------------------- |:------ | :---------------------------------------- | :------------------ |
| ['yum-mirror']['repopath'] | String | where to store the downloaded mirror data | '/var/local/mirror' |
| ['yum-mirror']['mirrors']  | Array  | which mirrors to use from data bags       |                     |

Usage
-----
#### yum-mirror::default

Include `yum-mirror` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[yum-mirror]"
  ]
}
```

If you want to sync mirrors, you also need to create databags with at least one repository for each release version and put them in the array node['yum-mirror']['mirrors'] matching the id of the data bag.

Data Bags
---------
#### yum-mirror::default
The default recipe doesn't need data bags to work, but won't do any mirror syncing. All mirrors are defined in data bags that have to look like the following:

```json
{
  "id": "centos6",
  "mirrorlists": {
    "base": "http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=os",
    "extras": "http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=extras",
    "updates": "http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=updates",
    "centosplus": "http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=centosplus"
  },
  "gpg": "http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6"
}
```

This data bag will add the standard repos for CentOS 6 and the corresponding GPG key. Currently the cookbook only supports mirrorlists and not single base urls.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Julian Tabel <j.tabel@bigpoint.net>

```text
Copyright:: 2015 Bigpoint GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
