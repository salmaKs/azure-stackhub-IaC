resource "azurestack_public_ip" "db_vm_public_ip" {
  name                = "db-vm-public-ip"
  location            = "dc2"
  resource_group_name = "RG-salma.ksantini"
  allocation_method   = "Static"
}

resource "azurestack_network_interface" "db_vm_nic" {
  name                = "bd-vm-nic"
  location            = "dc2"
  resource_group_name = "RG-salma.ksantini"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "bd-subnet"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurestack_public_ip.db_vm_public_ip.id
  }
}

resource "azurestack_linux_virtual_machine" "bd_vm" {
  name                  = "BD-vm"
  resource_group_name   = "RG-salma.ksantini"
  location              = "dc2"
  size                  = "Standard_DS1_v2"
  admin_username        = "salmaksantini"
  
  network_interface_ids = [azurestack_network_interface.bd_nic.id]
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  
  admin_ssh_key {
    username  = "salmaksantini"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  
  disable_password_authentication = true
  
  os_disk {
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
  }
}