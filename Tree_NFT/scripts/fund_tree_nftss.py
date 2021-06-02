from brownie import TreeCollection
from scripts.helpful_scripts import fund_nft_tree

def main():
    tree_collection = TreeCollection[len(TreeCollection) - 1]
    fund_nft_tree(tree_collection)