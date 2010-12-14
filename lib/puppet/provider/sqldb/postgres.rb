Puppet::Type.type(:sqldb).provide(:postgres) do
  desc "Postgres provider for creation of db using the
    database type."

  include Puppet::Util::Execution

  commands :psql => "/opt/local/lib/postgresql90/bin/psql"
  commands :createdb => "/opt/local/lib/postgresql90/bin/createdb"
  commands :dropdb => "/opt/local/lib/postgresql90/bin/dropdb"

  def exists?
    cmd = [command(:psql)] << "-d" << @resource[:name]

    output, status = Puppet::Util::SUIDManager.run_and_capture(
      cmd, resource[:runas].to_s
    )

    if status == 0
      true
    else
      false
    end
  end

  def create
    if exists?
      info "Database @resource[:name] exists"
      return nil
    else
      cmd = [command(:createdb)] << @resource[:name] << @resource[:owner]
      Puppet::Util::SUIDManager.run_and_capture(
        cmd, resource[:runas].to_s
      )
    end
  end

  def delete
    unless exists?
      info "Database @resource[:name] is already absent"
      return nil
    else
      cmd = [command(:dropdb)] << @resource[:name]
      Puppet::Util::SUIDManager.run_and_capture(
        cmd, resource[:runas].to_s
      )
    end
  end
end
