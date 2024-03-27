using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ButtonManager : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Restart()
    {
        SceneManager.LoadScene("MainMenu");
    }

    public void DoExitGame()
    {
        Application.Quit();
    }

    public void GoToLevel()
    {
        SceneManager.LoadScene("stand1");
    }
}
