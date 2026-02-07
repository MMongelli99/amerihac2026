{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Data.Monoid (mconcat)
import Data.Aeson

main :: IO ()
main = scotty 3000 $ do
    get "/" $ do
        html "Hello from Scotty!"

    get "/hello/:name" $ do
        name <- pathParam "name"
        text $ mconcat ["Hello, ", name, "!"]

    get "/json" $ do
        json $ object ["message" .= ("Hello from JSON!" :: String)]
