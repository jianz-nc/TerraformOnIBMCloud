variable "dal10_public_vlan_id" {}
variable "dal10_private_vlan_id" {}
variable "dal12_public_vlan_id" {}
variable "dal12_private_vlan_id" {}
variable "dal13_public_vlan_id" {}
variable "dal13_private_vlan_id" {}

resource "ibm_container_cluster" "tfcluster" {
  name            = "test-kubecluster"
  datacenter      = "dal10"
  machine_type    = "b3c.4x16"
  hardware        = "shared"
  public_vlan_id  = var.dal10_public_vlan_id
  private_vlan_id = var.dal10_private_vlan_id

  kube_version = "1.22"

  default_pool_size = 3

  public_service_endpoint  = "true"
  private_service_endpoint = "true"

  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool" "workerpool" {
  worker_pool_name = "tf-workerpool"
  machine_type     = "u3c.2x4"
  cluster          = ibm_container_cluster.tfcluster.id
  size_per_zone    = 2
  hardware         = "shared"

  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool_zone_attachment" "tfwp-dal10" {
  cluster           = ibm_container_cluster.tfcluster.id
  worker_pool       = element(split("/", ibm_container_worker_pool.workerpool.id), 1)
  zone              = "dal10"
  public_vlan_id    = var.dal10_public_vlan_id
  private_vlan_id   = var.dal10_private_vlan_id
  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool_zone_attachment" "tfwp-dal12" {
  cluster           = ibm_container_cluster.tfcluster.id
  worker_pool       = element(split("/", ibm_container_worker_pool.workerpool.id), 1)
  zone              = "dal12"
  public_vlan_id    = var.dal12_public_vlan_id
  private_vlan_id   = var.dal12_private_vlan_id
  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool_zone_attachment" "tfwp-dal13" {
  cluster           = ibm_container_cluster.tfcluster.id
  worker_pool       = element(split("/", ibm_container_worker_pool.workerpool.id), 1)
  zone              = "dal13"
  public_vlan_id    = var.dal13_public_vlan_id
  private_vlan_id   = var.dal13_private_vlan_id
  resource_group_id = data.ibm_resource_group.resource_group.id
}
