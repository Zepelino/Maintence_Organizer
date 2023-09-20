using Godot;
using System;
using System.Data.SqlClient;
using System.Net;

public class Control : Godot.Control
{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
		SqlConnection con = null;
		string constr = @"server=.\CDS;database=teste;";
		con = new SqlConnection(constr);
		
		try{
			con.Open();
			OS.Alert("Open", "Message Box");
		}
			catch(Exception ex){
			OS.Alert(ex.ToString(), "Message Box");
		}
		
		GD.Print(con.State.ToString());
		
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
