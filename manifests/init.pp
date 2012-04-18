# This class maintains the system's "message of the day" file.
#
# Simply including this class should retain the normal content
# of the motd file, but allow it to be augmented with custom
# information using the resource types defined in this module.
#
# == Parameters
#
# - empty: whether to start out with an empty motd file (true)
#   or to try to retain the content provided by the operating
#   system and to augment it (false; the default).
class motd($empty = false)
{
  case $::operatingsystem {
    Debian: {
      $target  = '/etc/motd.tail'
      $target2 = '/var/run/motd'

      file_concat { $target:
        owner => 'root',
        group => 'root',
        mode  => '0444'
      }

      if ! $empty {
        file_fragment { 'motd(Debian)':
          path    => $target,
          content => template('motd/motd.debian'),
          order   => '00'
        }
      }

      # from /etc/rcS.d/S55bootmisc.sh on lenny
      exec { 'update-real-motd':
        path        => '/bin',
        command     => "uname -snrvm > ${target2} && cat ${target} >> ${target2}",
        subscribe   => File_concat[$target],
        refreshonly => true
      }
    }

    Solaris: {
      # default Solaris motd only provides OS name, version and release date,
      # therefore we opt to just include output of 'uname -snrvm' and ignore $empty
      # to do this properly we adopt the method used in debian section of this class

      $target  = '/etc/motd.tail'
      $target2 = '/etc/motd'

      file_concat { $target:
        owner => 'root',
        group => 'root',
        mode  => '0444'
      }

      # from /etc/rcS.d/S55bootmisc.sh on lenny
      exec { 'update-real-motd':
        path        => '/bin',
        command     => "uname -snrvm > ${target2} && cat ${target} >> ${target2}",
        subscribe   => File[$target],
        refreshonly => true
      }
    }

    default: {
      fail("${::operatingsystem} is unsupported")
    }
  }
}
