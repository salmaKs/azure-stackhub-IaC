# Création de l'interface réseau pour la VM d'automatisation
resource "azurestack_network_interface" "automation_nic" {
  name                = "automation-nic"
  location            = azurestack_virtual_network.vnet.location
  resource_group_name = azurestack_virtual_network.vnet.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurestack_subnet.automation_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurestack_public_ip.automation_public_ip.id
  }
  }

# Création d'une IP publique pour la VM
resource "azurestack_public_ip" "automation_public_ip" {
  name                = "automation-public-ip"
  location            = azurestack_virtual_network.vnet.location
  resource_group_name = azurestack_virtual_network.vnet.resource_group_name
  allocation_method   = "Static"
}

# Création de la VM d'automatisation
resource "azurestack_linux_virtual_machine" "automation_vm" {
  name                = "automation-vm"
  resource_group_name = azurestack_virtual_network.vnet.resource_group_name
  location            = azurestack_virtual_network.vnet.location
  size                = "Standard_D2_v2"
  admin_username      = "salmaksantini"
  network_interface_ids = [azurestack_network_interface.automation_nic.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "2022.04.19"
  }

  admin_ssh_key {
    username   = "salmaksantini"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  disable_password_authentication = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

