using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkyboxLerp : MonoBehaviour
{

    public Material MorningSkybox;
    public Material DaySkybox;
    public Material EveningSkybox;
    public Material TransiEveningNightSkybox;
    public Material NightSkybox;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
        if (TimeSystem.currentTime >= 0 && TimeSystem.currentTime <= 0.25)
        {
            LerpMorning();
        }else if(TimeSystem.currentTime >= 0.25 && TimeSystem.currentTime <= 0.5)
        {
            LerpDay();
        }else if (TimeSystem.currentTime >= 0.5 && TimeSystem.currentTime <= 0.75)
        {
            LerpEvening();
        }
        else if ((TimeSystem.currentTime >= 0.75 && TimeSystem.currentTime < 1))
        {
            
            LerpNight();
        }




    }

    void LerpMorning()
    {
        float currentMorningTime = TimeSystem.currentTime * 4;

        RenderSettings.skybox.Lerp(MorningSkybox, DaySkybox, currentMorningTime);
    }

    void LerpDay()
    {
        float currentDayTime = (TimeSystem.currentTime - 0.25f) * 4;

        RenderSettings.skybox.Lerp(DaySkybox, EveningSkybox, currentDayTime);
    }

    void LerpEvening()
    {
        float currentEveningTime = (TimeSystem.currentTime - 0.5f) * 4;
        
        
        if (currentEveningTime >= 0 && currentEveningTime <= 0.5f)
        {
            Debug.Log(currentEveningTime * 1.3f);
            RenderSettings.skybox.Lerp(EveningSkybox, TransiEveningNightSkybox, Mathf.InverseLerp(0,1,currentEveningTime * 1.3f));
        }
        else if (currentEveningTime >= 0.5f && currentEveningTime <= 1)
        {
            Debug.Log((currentEveningTime - 0.5f) * 4);
            RenderSettings.skybox.Lerp(TransiEveningNightSkybox, NightSkybox, Mathf.InverseLerp(0, 1, (currentEveningTime - 0.5f) * 4));
        }
    }

    void LerpNight()
    {
        float currentNightTime = ((TimeSystem.currentTime - 0.75f) *4);

        if (currentNightTime >= 0 && currentNightTime <= 0.5f)
        {
            Debug.Log(currentNightTime * 1.3f);
            RenderSettings.skybox.Lerp(NightSkybox, TransiEveningNightSkybox, Mathf.InverseLerp(0, 1, currentNightTime * 1.3f));
        }
        else if (currentNightTime >= 0.5f && currentNightTime <= 1)
        {
            Debug.Log((currentNightTime - 0.5f) * 4);
            RenderSettings.skybox.Lerp(TransiEveningNightSkybox, MorningSkybox, Mathf.InverseLerp(0, 1, (currentNightTime - 0.5f) * 4));
        }

        
        
        
    }

    
}
