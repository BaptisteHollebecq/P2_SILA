using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkyboxLerp : MonoBehaviour
{

    public Material MorningSkybox;
    public Material TransiMorningDay;
    public Material DaySkybox;
    public Material TransiDayEvening;
    public Material EveningSkybox;
    public Material TransiEveningNightSkybox;
    public Material NightSkybox;
    public Material TransiNightMorningSkybox;


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

        

        if (currentMorningTime >= 0 && currentMorningTime <= 0.75f)
        {

            RenderSettings.skybox.Lerp(MorningSkybox, TransiMorningDay, Mathf.InverseLerp(0, 1, currentMorningTime * 1.3f));
        }
        else if (currentMorningTime >= 0.75f && currentMorningTime <= 1)
        {

            RenderSettings.skybox.Lerp(TransiMorningDay, DaySkybox, Mathf.InverseLerp(0, 1, (currentMorningTime - 0.75f) * 4));
        }
    }

    void LerpDay()
    {
        float currentDayTime = (TimeSystem.currentTime - 0.25f) * 4;

        

        if (currentDayTime >= 0 && currentDayTime <= 0.75f)
        {

            RenderSettings.skybox.Lerp(DaySkybox, TransiDayEvening, Mathf.InverseLerp(0, 1, currentDayTime * 1.3f));
        }
        else if (currentDayTime >= 0.75f && currentDayTime <= 1)
        {

            RenderSettings.skybox.Lerp(TransiDayEvening, EveningSkybox, Mathf.InverseLerp(0, 1, (currentDayTime - 0.75f) * 4));
        }
    }

    void LerpEvening()
    {
        float currentEveningTime = (TimeSystem.currentTime - 0.5f) * 4;
        
        
        if (currentEveningTime >= 0 && currentEveningTime <= 0.25f)
        {
            
            RenderSettings.skybox.Lerp(EveningSkybox, TransiEveningNightSkybox, Mathf.InverseLerp(0,1,currentEveningTime * 1.3f));
        }
        else if (currentEveningTime >= 0.25f && currentEveningTime <= 1)
        {
            
            RenderSettings.skybox.Lerp(TransiEveningNightSkybox, NightSkybox, Mathf.InverseLerp(0, 1, (currentEveningTime - 0.25f) * 4));
        }
    }

    void LerpNight()
    {
        float currentNightTime = ((TimeSystem.currentTime - 0.75f) *4);

        if (currentNightTime >= 0 && currentNightTime <= 0.75f)
        {
            
            RenderSettings.skybox.Lerp(NightSkybox, TransiNightMorningSkybox, Mathf.InverseLerp(0, 1, currentNightTime * 1.3f));
        }
        else if (currentNightTime >= 0.75f && currentNightTime <= 1)
        {
            
            RenderSettings.skybox.Lerp(TransiNightMorningSkybox, MorningSkybox, Mathf.InverseLerp(0, 1, (currentNightTime - 0.75f) * 4));
        }

        
        
        
    }

    
}
