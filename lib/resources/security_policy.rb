# Security Configuration and Analysis
#
# Export local security policy:
# secedit /export /cfg secpol.cfg
#
# @link http://www.microsoft.com/en-us/download/details.aspx?id=25250
# 
# In Windows, some security options are managed differently that the local GPO
# All local GPO parameters can be examined via Registry, but not all security 
# parameters. Therefore we need a combination of Registry and secedit output

module Serverspec
  module Type
     
    class SecurityPolicy < Base

      # static variable, shared across all instances
      @@loaded = false
      @@policy = nil
      @@exit_status = nil
      
      # load security content
      def load
        # export the security policy
        @runner.run_command('secedit /export /cfg win_secpol.cfg')
        # store file content
        command_result ||= @runner.run_command('type win_secpol.cfg')
        # delete temp file
        @runner.run_command('del win_secpol.cfg')

        @@exit_status = command_result.exit_status.to_i
        @@policy = command_result.stdout

        @@loaded = true

        # returns self
        self
      end

      def method_missing(method)

        # load data if needed
        if (@@loaded == false)
          load
        end

        # find line with key
        key = method.to_s
        target = ""
        @@policy.each_line {|s| 
          target = s.strip if s.match(/\b#{key}\s*=\s*(.*)\b/)
        }

        # extract variable value
        result = target.match(/[=]{1}\s*(?<value>.*)/)
        val = result[:value]
        val = val.to_i if val.match(/^\d+$/)
        val
      end

      def to_s
        %Q[Security Policy]
      end

    end

    def security_policy()
      SecurityPolicy.new()
    end

  end
end

include Serverspec::Type
