const express=require("express")
const jwt=require("jsonwebtoken")
require("dotenv").config()

const verifyJWT=(req,res,next)=>{
    const token=req.headers["x-auth-token"]
    if(typeof token!=="undefined")
    {
      const bearer=token.split(" ")
      const bearertoken=bearer[1];
      req.token=bearertoken;
      jwt.verify(req.token,process.env.SECRET_KEY,(err,authData)=>{
        if(err)
        {
          res.status(400).json("invalid token")
        }
        else{
          next()
        }
      })
     
  

    }
    else{
      res.status(400).json({msg:"Token is not valid"})
    }
  }

  module.exports=verifyJWT