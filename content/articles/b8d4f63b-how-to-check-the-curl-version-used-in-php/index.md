---
title: "How to check the cURL version used in PHP?"
date: 2023-10-11T10:08:54+01:00
draft: false
summary: "With a [high severity security issue](https://curl.se/docs/CVE-2023-38545.html) just announced in curl, you might be wondering which curl version you are using in your PHP script. Here's how to find it."
types: ['tutorial']
subjects: ['php', 'curl', 'security']
---
The maintainers of curl have announced that they will release a new version today, October 11 2023. In the 8.4.0 release, they fixed [CVE-2023-38545: SOCKS5 heap buffer overflow](https://curl.se/docs/CVE-2023-38545.html).

You might be wondering which version of curl you are running. In PHP this is easy to do. The builtin [curl_version](https://www.php.net/manual/en/function.curl-version.php) function gives you all information you need.

Use it like this:
{{< highlight php >}}
curl_version();
{{< / highlight >}}

The return value will be an array with these details:

{{< highlight php >}}
Array(16) {
  ["version_number"]=> int()
  ["age"]=> int()
  ["features"]=> int()
  ["ssl_version_number"]=> int()
  ["version"]=> string() "x.x.x"
  ["host"]=> string() "host"
  ["ssl_version"]=> string() ""
  ["libz_version"]=> string() ""
  ["protocols"]=> array() {}
  ["ares"]=> string() ""
  ["ares_num"]=> int() 
  ["libidn"]=> string() ""
  ["iconv_ver_num"]=> int()
  ["libssh_version"]=> string() ""
  ["brotli_ver_num"]=> int()
  ["brotli_version"]=> string() ""
{{< / highlight >}}

The `version` index will give you the version of `curl` itself. Anything below `8.4.0` is vulnerable to this specific problem.

Whether or not your system is affected by this specific vulnerability also depends on your specific curl configuration. The way I read it, you are only affected if you have configured a SOCKS5 hostname or a (pre)proxy with a SOCKS5 schema.

*Update: 2023-10-13:*
[This article](https://jfrog.com/blog/curl-libcurl-october-2023-vulns-all-you-need-to-know/) explains nicely which configurations are affected, the default configuration is not.