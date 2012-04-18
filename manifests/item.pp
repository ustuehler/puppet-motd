# Maintain an itemised list in the system's "message of the day" file.
#
# == Parameters
#
# - content: item text (automatically wrapped and newline-terminated)
# - order: two digits between 00 and 99 determining the order of motd
#   fragments
define motd::item($content, $order = 10)
{
  motd::fragment { $name:
    content => template('motd/item.erb'),
    order   => $order
  }
}
