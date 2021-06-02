from brownie import accounts, TreeCollection, config, interface, network

OPENSEA_FORMAT = "https://testnets.opensea.io/assets/{}/{}"

def get_species(species_number):
    switch = {0:"PINE", 1:"OAK", 2:"BIRK", 3:"ACCACIA"}
    return switch[species_number]


def fund_nft_tree(nft_contract):
    dev = accounts.add(config["wallets"]["from_key"])
    # Get the most recent PriceFeed Object
    interface.LinkTokenInterface( config["networks"][network.show_active()]["link_token"]).transfer(nft_contract, config["networks"][network.show_active()]["fee"], {"from": dev})
    #This is how we get the ABI using the LinkTokenInterface
