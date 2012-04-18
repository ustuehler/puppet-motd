# Maintain a fragment of the system's "message of the day" file.
#
# == Parameters
#
# - content: fragment content (not automatically newline-terminated)
# - order: two digits between 00 and 99 that define the ordering of
#   motd fragments.
define motd::fragment($content, $order = 10)
{
  include motd

  file_fragment { "motd::fragment(${name})":
    path    => $motd::target,
    content => $content,
    order   => $order
  }
}
