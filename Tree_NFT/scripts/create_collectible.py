#!/usr/bin/python3
from brownie import TreeCollection, accounts, config
from scripts.helpful_scripts import get_species, fund_nft_tree
import time


STATIC_SEED = 123


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    tree_collection = TreeCollection[len(TreeCollection) - 1]
    fund_nft_tree(tree_collection)
    transaction = tree_collection.createCollectible(
        "None", STATIC_SEED, {"from": dev}
    )
    print("Waiting on second transaction...")
    # wait for the 2nd transaction
    transaction.wait(1)
    time.sleep(35)
    requestId = transaction.events["requestedCollectible"]["requestId"]
    token_id = tree_collection.requestIdToTokenId(requestId)
    species = get_species(tree_collection.tokenIdToBreed(token_id))
    print("Tree Species of tokenId {} is {}".format(token_id, species))
