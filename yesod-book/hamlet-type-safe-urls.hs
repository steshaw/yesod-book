#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package blaze-html
    --package blaze-markup
    --package shakespeare
    --package text
    --
    -Wall -fwarn-tabs
-}

{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}

import Text.Hamlet (Render, HtmlUrl, hamlet)
import Text.Blaze (Markup)
import Text.Blaze.Html.Renderer.String (renderHtml)
import Text.Blaze.Html5 ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

data MyRoute = Home | Fred

renderRoute :: Render MyRoute
renderRoute Home _ = "/home"
renderRoute Fred _ = "/fred"

fredWithBlaze :: HtmlUrl MyRoute
fredWithBlaze render = H.a ! A.href url $ "To go Fred"
  where
    url = H.textValue (render Fred [])

fred :: HtmlUrl MyRoute
fred = [hamlet|
  <a href=@{Fred}>Go to Fred
|]

footer :: HtmlUrl MyRoute
footer = [hamlet|
  <footer>
    Return to #
    <a href=@{Home}>Homepage
    .
|]

page :: Render MyRoute -> Markup
page = [hamlet|
  <body>
    ^{fredWithBlaze}
    <p>This is my page.
    ^{fred}
    ^{footer}
    ^{fred}
|]

main :: IO ()
main = putStrLn $ renderHtml (page renderRoute)
