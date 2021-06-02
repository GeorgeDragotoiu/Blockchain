from brownie import TreeCollection, accounts, network, config
from scripts.helpful_scripts import fund_nft_tree

def main():
    dev = accounts.add(config['wallets']['from_key'])
    print(network.show_active())
    publish_source = False
    tree_collection = TreeCollection.deploy(
        config["networks"][network.show_active()]["vrf_coordinator"], # from the config, we go to the networks section, choose the active network and take the parameter
        config["networks"][network.show_active()]["link_token"],
        config["networks"][network.show_active()]["keyhash"],
        {"from": dev}, # we are deploying from the dev account
        publish_source=publish_source, # we publish on etherscan if our publish API is set
    )
    fund_nft_tree(tree_collection)
    return tree_collection
