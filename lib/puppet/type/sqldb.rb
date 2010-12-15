# Type that can create databases.

module Puppet

  newtype(:sqldb) do

    ensurable do
      desc "Create or remove a database."

      newvalue(:present) do
        provider.create
      end

      newvalue(:absent) do
        provider.delete
      end
    end

    newproperty(:owner) do
      desc "Which database user owns the database."
      defaultto :postgres
    end

    newparam(:name) do
      desc "The name of the database."
      isnamevar
    end

    newparam(:runas) do
      desc "User to run psql commands if other than
        postgres."
      defaultto :postgres
    end
  end
end
