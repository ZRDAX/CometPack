local lfs = require("lfs")
local utils = {}

function utils.unzip(file, destination)
  local command = string.format("tar -xzf %s -C %s", file, destination)
  return os.execute(command)
end

function utils.create_dir(path)
  if not lfs.attributes(path) then
      lfs.mkdir(path)
  end
end

function utils.delete_dir(path)
  local command = string.format("rm -rf %s", path)
  return os.execute(command)
end

return utils
